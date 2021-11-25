

from django.contrib import admin
from django.urls import path
from django.urls.conf import include
from .views import MessageView

urlpatterns = [
    path('message/',MessageView.as_view()),
    #path('chat/',ChatView.as_view())
]