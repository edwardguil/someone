

from django.contrib import admin
from django.urls import path
from django.urls.conf import include
from .views import ChatView,MessageView

urlpatterns = [
    path('chat/',ChatView.as_view()),
    path('message/',MessageView.as_view())
]