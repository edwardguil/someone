from django.db.models.fields.related import ForeignKey
from rest_framework import serializers
from rest_framework.serializers import Serializer
from rest_framework.views import APIView
from rest_framework.response import Response
from someoneApi.settings import SECRET_KEY
from .serializers import MessageSerializer
import requests
import os
from .models import Message, Chat
from .somone import *
from users.models import TempUser
import jwt


class MessageView(APIView):
    def post(self,request):
        
        encondedJwt = request.headers['token']
        decodedJwt = jwt.decode(encondedJwt, SECRET_KEY, algorithms=["HS256"])
        userId = decodedJwt['id']
        chat = Chat.objects.get(admin_id=userId)
        user = TempUser.objects.get(pk=userId)
        decodedRequest = {"chat":chat.id,"user":user.id,"text":request.data['text']}
        serializer = MessageSerializer(data=decodedRequest)
        serializer.is_valid(raise_exception=True)
        message = serializer.save()

     
        if user.id != 1:
            ##Need to get list of current Message history:
            messagesList = Message.objects.filter(chat=chat.id)
            serializer = MessageSerializer(messagesList, many=True)
            prompt = " "
            firstName = message.user.firstName
            aiName = "Someone"
            for item in serializer.data:
                if item['user'] != 1:
                    if "The following is a conversation with" in item['text']:
                        s = item["text"]
                        start = s.find("The following is a conversation with a ") + len("The following is a conversation with a ")
                        end = s.find(".")
                        aiName = s[start:end]

                        newMessageText = item['text'] +"\n"
                        prompt = prompt + newMessageText
                    else:
                        newMessageText = firstName +": "+item['text']+"\n"
                        prompt = prompt + newMessageText
                else:
                    newMessageText = aiName + " : "+item['text']+"\n"
                    prompt = prompt + newMessageText
            
            ##Need to call AI API Here let, return = aiResponse
            someoneResp = someone(prompt,firstName,aiName)
            if someoneResp != '':
                if ":" in someoneResp:
                    someoneResp = someoneResp[someoneResp.index(':')+2:]
                    someoneRespScore = openai.Completion.create(engine="content-filter-alpha-c4",prompt = "<|endoftext|>"+someoneResp+"\n--\nLabel:",
                
                temperature=0,
                max_tokens=150,
                top_p=1,
                frequency_penalty=0,
                presence_penalty=0,
                logprobs=10)
                output_label = someoneRespScore["choices"][0]["text"]

                toxic_threshold = -0.355

                if someoneRespScore == "2":
                    logprobs = someoneRespScore["choices"][0]["logprobs"]["top_logprobs"][0]

                    # If the model is not sufficiently confident in "2",
                    # choose the most probable of "0" or "1"
                    # Guaranteed to have a confidence for 2 since this was the selected token.
                    if logprobs["2"] < toxic_threshold:
                        logprob_0 = logprobs.get("0", None)
                        logprob_1 = logprobs.get("1", None)

                        # If both "0" and "1" have probabilities, set the output label
                        # to whichever is most probable
                        if logprob_0 is not None and logprob_1 is not None:
                            if logprob_0 >= logprob_1:
                                output_label = "0"
                            else:
                                output_label = "1"
                        # If only one of them is found, set output label to that one
                        elif logprob_0 is not None:
                            output_label = "0"
                        elif logprob_1 is not None:
                            output_label = "1"
                
                        # If neither "0" or "1" are available, stick with "2"
                        # by leaving output_label unchanged.

                # if the most probable token is none of "0", "1", or "2"
                # this should be set as unsafe
                if output_label not in ["0", "1", "2"]:
                    output_label = "2"
                
                if output_label == "2":
                    someoneResp = "This response was flagged as 'unsafe' and will not be added to the chat history. Please try messaging something else again."
                
                aiRequestData = {"text":someoneResp,"user":1,"chat":message.chat.id}
                serializer = MessageSerializer(data=aiRequestData)
                serializer.is_valid(raise_exception=True)
                aiMessage = serializer.save()
                
                response = Response()
                response.data = {"text":someoneResp}
                return response
            else:
                response = Response()
                response.data = {"text":"...."}
                return response
        else:
            #This is if request is fom the above post request adding AI message into db
            response = Response()
            response.data = {"log":"Storing aiResponse to message table"}
            return response
