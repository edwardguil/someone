from rest_framework import serializers
from .models import Chat, Message



class ChatSerializer(serializers.ModelSerializer):
    """A Serializer for messaging.models.chat"""

    class Meta:
        model = Chat
        fields = ['admin','participants']

class MessageSerializer(serializers.ModelSerializer):

    class Meta:
        model = Message
        fields = ['user','chat','text']

    