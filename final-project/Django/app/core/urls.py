from django.contrib import admin
from django.urls import path

from main.views import healthcheck

urlpatterns = [
    path("admin/", admin.site.urls),
    path("", healthcheck),
    path("healthz/", healthcheck),
]
