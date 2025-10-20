# Admin panel configuration removed for now
# Can be re-enabled later if needed

# from django.contrib import admin
# from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
# from .models import User

# Uncomment below to enable admin panel
# class UserAdmin(BaseUserAdmin):
#     list_display = ('email', 'full_name', 'is_active', 'is_staff', 'created_at')
#     list_filter = ('is_staff', 'is_active', 'created_at')
#     fieldsets = (
#         (None, {'fields': ('email', 'password')}),
#         ('Personal info', {'fields': ('full_name',)}),
#         ('Permissions', {'fields': ('is_active', 'is_staff', 'is_superuser')}),
#         ('Important dates', {'fields': ('last_login', 'created_at', 'updated_at')}),
#     )
#     add_fieldsets = (
#         (None, {
#             'classes': ('wide',),
#             'fields': ('email', 'full_name', 'password1', 'password2'),
#         }),
#     )
#     search_fields = ('email', 'full_name')
#     ordering = ('-created_at',)
#     readonly_fields = ('created_at', 'updated_at', 'last_login')
#     filter_horizontal = ()
#
# admin.site.register(User, UserAdmin)

