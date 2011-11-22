# encoding: utf-8
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models

class Migration(SchemaMigration):

    def forwards(self, orm):
        
        # Adding field 'Person.something_else'
        db.add_column('sample_person', 'something_else', self.gf('django.db.models.fields.IntegerField')(default=1), keep_default=False)


    def backwards(self, orm):
        
        # Deleting field 'Person.something_else'
        db.delete_column('sample_person', 'something_else')


    models = {
        'sample.person': {
            'Meta': {'object_name': 'Person'},
            'alias': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'last_name': ('django.db.models.fields.CharField', [], {'max_length': '100'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '25'}),
            'something': ('django.db.models.fields.IntegerField', [], {}),
            'something_else': ('django.db.models.fields.IntegerField', [], {})
        }
    }

    complete_apps = ['sample']
