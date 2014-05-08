from django.contrib import admin
from show.models import *

# Register your models here.
admin.site.register(Show)
admin.site.register(Phase)
admin.site.register(UserProfile)
admin.site.register(LogItem)
admin.site.register(Stream)

class ActionInline(admin.TabularInline):
    model = Action

class CueAdmin(admin.ModelAdmin):
    inlines = [
        ActionInline,
    ]

admin.site.register(Cue, CueAdmin)