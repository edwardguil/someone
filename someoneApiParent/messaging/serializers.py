from rest_framework import serializers
from .models import Message, Chat

class MessageSerializer(serializers.ModelSerializer):

    class Meta:
        model = Message
        fields = ['user','chat','text']

class ChatSerializer(serializers.ModelSerializer):

    class Meta:
        model = Chat
        fields = ['admin','ai']

    

    