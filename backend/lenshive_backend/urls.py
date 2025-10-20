from django.urls import path, include
from authentication.views import get_profile

urlpatterns = [
    # Admin panel removed for now
    # path('admin/', admin.site.urls),
    path('api/auth/', include('authentication.urls')),
    path('api/user/profile', get_profile, name='get_profile'),
]

