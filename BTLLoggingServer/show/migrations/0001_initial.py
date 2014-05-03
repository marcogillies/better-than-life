# -*- coding: utf-8 -*-
from south.utils import datetime_utils as datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Adding model 'Show'
        db.create_table(u'show_show', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('name', self.gf('django.db.models.fields.CharField')(max_length=20)),
            ('date', self.gf('django.db.models.fields.DateTimeField')()),
            ('act', self.gf('django.db.models.fields.IntegerField')(default=-1)),
            ('section', self.gf('django.db.models.fields.CharField')(default='advance', max_length=20)),
        ))
        db.send_create_signal(u'show', ['Show'])

        # Adding model 'UserProfile'
        db.create_table(u'show_userprofile', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('user', self.gf('django.db.models.fields.related.OneToOneField')(to=orm['auth.User'], unique=True)),
            ('show', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['show.Show'])),
            ('credit', self.gf('django.db.models.fields.IntegerField')()),
            ('upgradeStatus', self.gf('django.db.models.fields.BooleanField')()),
            ('colour', self.gf('django.db.models.fields.TextField')()),
            ('mouseX', self.gf('django.db.models.fields.FloatField')()),
            ('mouseY', self.gf('django.db.models.fields.FloatField')()),
        ))
        db.send_create_signal(u'show', ['UserProfile'])

        # Adding model 'LogItem'
        db.create_table(u'show_logitem', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('user', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['auth.User'])),
            ('show', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['show.Show'])),
            ('date', self.gf('django.db.models.fields.DateTimeField')(auto_now_add=True, blank=True)),
            ('act', self.gf('django.db.models.fields.IntegerField')()),
            ('section', self.gf('django.db.models.fields.CharField')(max_length=20)),
            ('category', self.gf('django.db.models.fields.TextField')()),
            ('content', self.gf('django.db.models.fields.TextField')()),
        ))
        db.send_create_signal(u'show', ['LogItem'])

        # Adding model 'Session'
        db.create_table(u'show_session', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('name', self.gf('django.db.models.fields.CharField')(max_length=30)),
            ('SEID', self.gf('django.db.models.fields.IntegerField')()),
            ('type', self.gf('django.db.models.fields.CharField')(max_length=20)),
        ))
        db.send_create_signal(u'show', ['Session'])

        # Adding model 'Cue'
        db.create_table(u'show_cue', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('keyword', self.gf('django.db.models.fields.CharField')(max_length=200)),
            ('session', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['show.Session'], null=True, blank=True)),
        ))
        db.send_create_signal(u'show', ['Cue'])

        # Adding model 'Action'
        db.create_table(u'show_action', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('cue', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['show.Cue'])),
            ('order', self.gf('django.db.models.fields.IntegerField')()),
            ('actionType', self.gf('django.db.models.fields.CharField')(max_length=20)),
            ('channel', self.gf('django.db.models.fields.IntegerField')(default=-1, blank=True)),
            ('value', self.gf('django.db.models.fields.IntegerField')(default=-1, blank=True)),
            ('address', self.gf('django.db.models.fields.CharField')(max_length=200, blank=True)),
            ('textValue', self.gf('django.db.models.fields.CharField')(max_length=200, blank=True)),
            ('_order', self.gf('django.db.models.fields.IntegerField')(default=0)),
        ))
        db.send_create_signal(u'show', ['Action'])


    def backwards(self, orm):
        # Deleting model 'Show'
        db.delete_table(u'show_show')

        # Deleting model 'UserProfile'
        db.delete_table(u'show_userprofile')

        # Deleting model 'LogItem'
        db.delete_table(u'show_logitem')

        # Deleting model 'Session'
        db.delete_table(u'show_session')

        # Deleting model 'Cue'
        db.delete_table(u'show_cue')

        # Deleting model 'Action'
        db.delete_table(u'show_action')


    models = {
        u'auth.group': {
            'Meta': {'object_name': 'Group'},
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'unique': 'True', 'max_length': '80'}),
            'permissions': ('django.db.models.fields.related.ManyToManyField', [], {'to': u"orm['auth.Permission']", 'symmetrical': 'False', 'blank': 'True'})
        },
        u'auth.permission': {
            'Meta': {'ordering': "(u'content_type__app_label', u'content_type__model', u'codename')", 'unique_together': "((u'content_type', u'codename'),)", 'object_name': 'Permission'},
            'codename': ('django.db.models.fields.CharField', [], {'max_length': '100'}),
            'content_type': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['contenttypes.ContentType']"}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '50'})
        },
        u'auth.user': {
            'Meta': {'object_name': 'User'},
            'date_joined': ('django.db.models.fields.DateTimeField', [], {'default': 'datetime.datetime.now'}),
            'email': ('django.db.models.fields.EmailField', [], {'max_length': '75', 'blank': 'True'}),
            'first_name': ('django.db.models.fields.CharField', [], {'max_length': '30', 'blank': 'True'}),
            'groups': ('django.db.models.fields.related.ManyToManyField', [], {'symmetrical': 'False', 'related_name': "u'user_set'", 'blank': 'True', 'to': u"orm['auth.Group']"}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'is_active': ('django.db.models.fields.BooleanField', [], {'default': 'True'}),
            'is_staff': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
            'is_superuser': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
            'last_login': ('django.db.models.fields.DateTimeField', [], {'default': 'datetime.datetime.now'}),
            'last_name': ('django.db.models.fields.CharField', [], {'max_length': '30', 'blank': 'True'}),
            'password': ('django.db.models.fields.CharField', [], {'max_length': '128'}),
            'user_permissions': ('django.db.models.fields.related.ManyToManyField', [], {'symmetrical': 'False', 'related_name': "u'user_set'", 'blank': 'True', 'to': u"orm['auth.Permission']"}),
            'username': ('django.db.models.fields.CharField', [], {'unique': 'True', 'max_length': '30'})
        },
        u'contenttypes.contenttype': {
            'Meta': {'ordering': "('name',)", 'unique_together': "(('app_label', 'model'),)", 'object_name': 'ContentType', 'db_table': "'django_content_type'"},
            'app_label': ('django.db.models.fields.CharField', [], {'max_length': '100'}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'model': ('django.db.models.fields.CharField', [], {'max_length': '100'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '100'})
        },
        u'show.action': {
            'Meta': {'ordering': "(u'_order',)", 'object_name': 'Action'},
            '_order': ('django.db.models.fields.IntegerField', [], {'default': '0'}),
            'actionType': ('django.db.models.fields.CharField', [], {'max_length': '20'}),
            'address': ('django.db.models.fields.CharField', [], {'max_length': '200', 'blank': 'True'}),
            'channel': ('django.db.models.fields.IntegerField', [], {'default': '-1', 'blank': 'True'}),
            'cue': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['show.Cue']"}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'order': ('django.db.models.fields.IntegerField', [], {}),
            'textValue': ('django.db.models.fields.CharField', [], {'max_length': '200', 'blank': 'True'}),
            'value': ('django.db.models.fields.IntegerField', [], {'default': '-1', 'blank': 'True'})
        },
        u'show.cue': {
            'Meta': {'object_name': 'Cue'},
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'keyword': ('django.db.models.fields.CharField', [], {'max_length': '200'}),
            'session': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['show.Session']", 'null': 'True', 'blank': 'True'})
        },
        u'show.logitem': {
            'Meta': {'object_name': 'LogItem'},
            'act': ('django.db.models.fields.IntegerField', [], {}),
            'category': ('django.db.models.fields.TextField', [], {}),
            'content': ('django.db.models.fields.TextField', [], {}),
            'date': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'section': ('django.db.models.fields.CharField', [], {'max_length': '20'}),
            'show': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['show.Show']"}),
            'user': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['auth.User']"})
        },
        u'show.session': {
            'Meta': {'object_name': 'Session'},
            'SEID': ('django.db.models.fields.IntegerField', [], {}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '30'}),
            'type': ('django.db.models.fields.CharField', [], {'max_length': '20'})
        },
        u'show.show': {
            'Meta': {'object_name': 'Show'},
            'act': ('django.db.models.fields.IntegerField', [], {'default': '-1'}),
            'date': ('django.db.models.fields.DateTimeField', [], {}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '20'}),
            'section': ('django.db.models.fields.CharField', [], {'default': "'advance'", 'max_length': '20'})
        },
        u'show.userprofile': {
            'Meta': {'object_name': 'UserProfile'},
            'colour': ('django.db.models.fields.TextField', [], {}),
            'credit': ('django.db.models.fields.IntegerField', [], {}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'mouseX': ('django.db.models.fields.FloatField', [], {}),
            'mouseY': ('django.db.models.fields.FloatField', [], {}),
            'show': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['show.Show']"}),
            'upgradeStatus': ('django.db.models.fields.BooleanField', [], {}),
            'user': ('django.db.models.fields.related.OneToOneField', [], {'to': u"orm['auth.User']", 'unique': 'True'})
        }
    }

    complete_apps = ['show']