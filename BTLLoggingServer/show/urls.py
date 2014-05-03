from django.conf.urls import patterns, url, include

from show import views

urlpatterns = patterns('',
    url(r'^$', views.index, name='index'),
    url(r'^login/$', views.user_login, name='login'),
    url(r'^upgrade/(?P<type>[a-zA-Z0-9_]+)/$', views.user_upgrade, name='upgrade'),
    url(r'^status/$', views.user_status, name='status'),
    url(r'^mouseMove/(?P<xpos>\d\.\d+)/(?P<ypos>\d\.\d+)/?$', views.mouseMove, name='mousemove'),
    url(r'^averageMouse/$', views.averageMouse, name='averageMouse'),
    url(r'^log/$', views.log, name='log'),
    url(r'^logdisplay/$', views.logDisplay, name='logdisplay'),
    url(r'^postQuestionnaire/$', views.postShowQuestionnaire, name='postQuestionnaire'),
    url(r'^register/$', views.Registration.as_view(), name='register'),
    url(r'^cues/$', views.cues, name='cues')
)