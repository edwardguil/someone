from django.db.models.fields.related import ForeignKey
from rest_framework import serializers
from rest_framework.serializers import Serializer
from rest_framework.views import APIView
from rest_framework.response import Response
from someoneApiParent.settings import SECRET_KEY
from .serializers import ChatSerializer,MessageSerializer
import requests
import os
from .models import *
from .somone import *

class ChatView(APIView): 
    def post(self,request):
        serializer = ChatSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        newChat = serializer.save()
        response = Response()
        response.data = {"id":newChat.id}
        return response

    def get(self,request):
        id = request.query_params['id']
        if id != None:
            chat = Chat.objects.get(id=id)
            serializer = ChatSerializer(chat)


        else:
            chat = Chat.objects.all()
            serializer = ChatSerializer(chat, many=True)
        
        response = Response()
        response.data = serializer.data

        return response

class MessageView(APIView):
    def post(self,request):
        serializer = MessageSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        message = serializer.save()


        #Check if message recieve to class if from AI or From User
        #AI will have id of 1
        if message.user.id != 1:
            ##Need to get list of current Message history:
            messagesList = Message.objects.filter(chat=message.chat.id)
            serializer = MessageSerializer(messagesList, many=True)
            testString = ""
            prompt = " "
            firstName = message.user.firstName
            aiName = "AI"
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

            aiRequestData = {"text":someoneResp,"user":1,"chat":message.chat.id}
            serializer = MessageSerializer(data=aiRequestData)
            serializer.is_valid(raise_exception=True)
            aiMessage = serializer.save()

            response = Response()
            response.data = {"text":someoneResp}
            return response
        else:
            #This is if request is fom the above post request adding AI message into db
            response = Response()
            response.data = {"log":"Storing aiResponse to message table"}
            return response

    def get(self,request):
        chat = request.query_params['chat']
        if chat != None:
            messages = Message.objects.filter(chat=chat)
            serializer = MessageSerializer(messages, many=True)


        else:
            messages = Message.objects.all()
            serializer = MessageSerializer(messages, many=True)
        
        response = Response()
        response.data = serializer.data

        return response
