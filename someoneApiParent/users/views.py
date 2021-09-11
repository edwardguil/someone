from re import S
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import serializers, status
from .models import TempUser
from .serializers import UserSerializer
import jwt
import datetime
from someoneApiParent.settings import SECRET_KEY
from messaging.models import Chat
from messaging.serializers import ChatSerializer





class UserView(APIView):
    def post(self, request):
        
        #Check if user exists:
        #user = TempUser.objects.filter(firstName=request.data.firstName).first()
        #if user is None:

        serializer = UserSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()

        #Prepping the data for serialzition before checking if it is valid
        #serialized = UserSerializer(data=request.data)
        #Checking if valid, using raise_exception to return expection
        #serialized.is_valid(raise_exception=True)
        #Saving data to User
        #newUser = serialized.save()
        chatData = {"admin":user.id,"ai":1}
        serializer = ChatSerializer(data=chatData)
        serializer.is_valid(raise_exception=True)
        newChat = serializer.save()
        print(newChat)
        payload = {
            'id': user.id,
            'iat': datetime.datetime.utcnow()
        }



        token = jwt.encode(payload, SECRET_KEY, algorithm='HS256')      
        response = Response()
        response.data = {'token':token}
        
        return response
    
    #def get(self,request):
    #    users = TempUser.objects.all()
    #    serializer = UserSerializer(users, many=True)
    #    response = Response()
    #    response.data = serializer.data

    #    return response


    