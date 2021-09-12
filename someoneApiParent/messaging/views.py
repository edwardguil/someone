from django.db.models.fields.related import ForeignKey
from rest_framework import serializers
from rest_framework.serializers import Serializer
from rest_framework.views import APIView
from rest_framework.response import Response
from someoneApiParent.settings import SECRET_KEY
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
