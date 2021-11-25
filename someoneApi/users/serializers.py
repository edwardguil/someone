from rest_framework import serializers
from .models import TempUser

class UserSerializer(serializers.ModelSerializer):
    """A Serializer for user.models.User"""

    class Meta:
        model = TempUser
        # Specific the model attributes needed for serialization
        fields = ['id','firstName']


 