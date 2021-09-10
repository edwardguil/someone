from re import S
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import serializers, status
from .models import TempUser
from .serializers import UserSerializer
import jwt
import datetime
from someoneApiParent.settings import SECRET_KEY
from django.http import JsonResponse
import sys




class UserView(APIView):
    def post(self, request):
        
        #Check if user exists:
        try:
            firstName = request.data['firstName']
        except:
            pass

        user = TempUser.objects.filter(firstName=firstName).first()
        if user is None:
            serializer = UserSerializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            newUser = serializer.save()

        #Prepping the data for serialzition before checking if it is valid
        #serialized = UserSerializer(data=request.data)
        #Checking if valid, using raise_exception to return expection
        #serialized.is_valid(raise_exception=True)
        #Saving data to User
        #newUser = serialized.save()
        
        payload = {
            'id': newUser.id,
            'iat': datetime.datetime.utcnow()
        }

        token = jwt.encode(payload, SECRET_KEY, algorithm='HS256')      
        response = Response()
        response.data = {'token':token}
        
        return response
    
    def get(self,request):
        users = TempUser.objects.all()
        serializer = UserSerializer(users, many=True)
        response = Response()
        response.data = serializer.data

        return response


    