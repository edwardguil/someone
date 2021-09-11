from rest_framework.views import APIView
from rest_framework.response import Response
from someoneApiParent.settings import SECRET_KEY
from .serializers import ChatSerializer,MessageSerializer
import requests
import os


class ChatView(APIView): 
    def post(self,request):
        serializer = ChatSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        newChat = serializer.save()
        response = Response()
        response.data = {"id":newChat.id}
        return response

class MessageView(APIView):
    def post(self,request):
        serializer = MessageSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        Message = serializer.save()

        #Check if message recieve to class if from AI or From User
        #AI will have id of 1
        if Message.user != 1:

            ##Need to call AI API Here let, return = aiResponse
            #aiResponse = requests.get('bleh')
            aiResponse = "test response from AI"
            #Once response has been recieve call "domain/messaging/message" to store AI Message in the db
            data = {
                "user":1,
                "chat":Message.chat,
                "text": aiResponse}
            
            messageResp = requests.post("http://127.0.0.1:8000/messaging/message/",data=data)
            response = Response()
            response.data = {"text":aiResponse}
            return response
        else:
            #This is if response is from AI
            pass
