# encoding: utf-8
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models

class Migration(SchemaMigration):

    def forwards(self, orm):
        
        # Adding model 'SampleOne'
        db.create_table('another_sample_sampleone', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('first_column', self.gf('django.db.models.fields.IntegerField')()),
            ('second_column', self.gf('django.db.models.fields.IntegerField')()),
            ('third_column', self.gf('django.db.models.fields.IntegerField')()),
        ))
        db.send_create_signal('another_sample', ['SampleOne'])


    def backwards(self, orm):
        
        # Deleting model 'SampleOne'
        db.delete_table('another_sample_sampleone')


    models = {
        'another_sample.sampleone': {
            'Meta': {'object_name': 'SampleOne'},
            'first_column': ('django.db.models.fields.IntegerField', [], {}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'second_column': ('django.db.models.fields.IntegerField', [], {}),
            'third_column': ('django.db.models.fields.IntegerField', [], {})
        }
    }

    complete_apps = ['another_sample']
