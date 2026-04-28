from django.contrib import admin
from django.http import JsonResponse
from django.urls import path


def home(_request):
    return JsonResponse(
        {
            "message": "Django is running in Docker",
            "database": "PostgreSQL",
            "proxy": "Nginx",
        }
    )


urlpatterns = [
    path("admin/", admin.site.urls),
    path("", home),
]

