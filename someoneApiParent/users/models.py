from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin

class CustomAccountManager(BaseUserManager):
    """Custom Account Manager Class
    
    This class is a required too override the existing django User class.
    Allows to specify attributes belonging to a user. 

    """

    def create_superuser(self, email,firstName, password, **other_fields):
        """Creates a superuser. 
        
        Super user is created via 'manage.py createsuperuser' in terminal. 
        A super user is used to login into /admin.

        Args:
            email (string): email for logging in
            password (string): password for loggin in

        Raises:
            ValueError: If is_staff or is_super user not true. 

        Returns:
            users.models.User: The created superuser
        """
        other_fields.setdefault('is_staff', True)
        other_fields.setdefault('is_superuser', True)
        other_fields.setdefault('is_active', True)

        if other_fields.get('is_staff') is not True:
            raise ValueError(
                'Superuser must be assigned to is_staff=True.')
        if other_fields.get('is_superuser') is not True:
            raise ValueError(
                'Superuser must be assigned to is_superuser=True.')

        return self.create_user(email,firstName, password **other_fields)

    def create_user(self, email, firstName, password, **other_fields):
        """Creates a user.

        Args:
            email (string): email for logging in
            password (string): password for loggin in

        Raises:
            ValueError: If email is not provided

        Returns:
            users.models.User: The created user
        """
        if not email:
            raise ValueError(('You must provide an email address'))

        email = self.normalize_email(email)
        user = self.model(email=email,firstName=firstName,**other_fields)
        user.set_password(password)

        user.save()
        return user


class User(AbstractBaseUser, PermissionsMixin):
    """A custom User class. Overrides existing django User class. """
    email = models.EmailField(('email address'), unique=True)
    firstName = models.CharField(max_length=200)
    is_staff = models.BooleanField(default=False)
    is_active = models.BooleanField(default=False)

    objects = CustomAccountManager()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = []

