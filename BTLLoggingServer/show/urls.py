from django.conf.urls import patterns, url

from show import views

urlpatterns = patterns('',
    url(r'^$', views.index, name='index'),
    url(r'^login/$', views.user_login, name='login'),
    url(r'^upgrade/$', views.user_upgrade, name='upgrade'),
    url(r'^mouseMove/(?P<xpos>\d\.\d+)/(?P<ypos>\d\.\d+)/?$', views.mouseMove, name='mousemove'),
    url(r'^averageMouse/$', views.averageMouse, name='averageMouse'),
    url(r'^log/$', views.log, name='log')

)