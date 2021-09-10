from rest_framework import serializers
from .models import Chat, Message



class ChatSerializer(serializers.ModelSerializer):
    """A Serializer for messaging.models.chat"""

    class Meta:
        model = Chat
        # Specific the model attributes needed for serialization
        fields = ['id', 'admin','participants', 'created']
        # Prevents password from being read
        extra_kwargs = {
            'password': {'write_only': True}
        }

    def create(self, validated_data):
        """Creates new User from validated data.

        Overrites existing create function from ModelSerializer. This
        is used indirectly via the serializer.save method.  
        
        Args:
            validated_data (dict): Dictionary of user information. 

        Returns:
            users.models.User : The newly created User object. 
        """
        password = validated_data.pop('password', None)
        instance = self.Meta.model(**validated_data)
        if password is not None:
            instance.set_password(password)
        instance.save()
        return instance


    def update(self, instance, validated_data):
        email = validated_data.get('email')
        firstName = validated_data.get('firstName')
        password = validated_data.get('password')
        if email is not None:
            instance.email = email 
        if password is not None:
            instance.set_password(password)
        if firstName is not None:
            instance.firstName = firstName
        instance.save()
        return instance
