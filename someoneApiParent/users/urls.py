

from django.contrib import admin
from django.urls import path
from django.urls.conf import include
from .views import UserView

urlpatterns = [
    path('',UserView.as_view())
]