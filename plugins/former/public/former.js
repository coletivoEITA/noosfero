var field_new_id = 0;

var DEFAULT_SETTINGS = {
  removeable: true,
  showRequired: true,
};

//Add new field in form
function field_add(parent, form, field, options) {
    var settings = jQuery.extend({}, DEFAULT_SETTINGS, options || {});
    
    if (field.id == 'new') {
        jQuery.ajax({
            url : "former/add_new_field",
            type: "post",
            data: {'form_identifier': form.toString()},
            dataType: "json",
            beforeSend: function(){
                jQuery( '#' +form + '_status').addClass("small-loading");
            },
            complete : function(response, object){
                jQuery('#' +form + '_status').removeClass("small-loading");
                var new_field_obj = jQuery.parseJSON(response.responseText);
                field.id = new_field_obj.field_id;
                jQuery(parent).append(new_field(form, field, settings));
            }
      });
    } else {
        jQuery(parent).append(new_field(form, field, settings));
    }

    return false;
}

function new_field(form, field, settings)
{
    id = 'forms['+ form +'][fields]['+ field.id +']';

    var form_field = jQuery('<form/>', {
        'id': id,
        'method' : 'post',
        'action' : "former/save_field",
        'remote' : 'true',
        'class'  : 'former-field former-field-type-option'
    }).hover(
        function() {
            jQuery(this).addClass('hover');
        },
        function() {
            jQuery(this).removeClass('hover');
        }
    ).submit(function() {
        jQuery.ajax( {
            url : "former/save_field",
            type: "post",
            data: jQuery(this).serialize(),
            beforeSend: function(){
                jQuery( '#' + gsub_value(id) + 'options_status').addClass("small-loading");
                jQuery( '#' + gsub_value(id) + 'options_status').text('')
	    },
            complete : function(response){
                jQuery( '#' + gsub_value(id) + 'options_status').removeClass("small-loading");
                var save_response = jQuery.parseJSON(response.responseText);
                jQuery( '#' + gsub_value(id) + 'options_status').text(save_response.status_msg);
            }
        });
        return false;
     });

    if (settings.showRequired) {
      var required_checkbox = jQuery('<input>',{
          'type' : 'checkbox',
          'id':   gsub_value(id+'[required]'),
          'name' : id+'[required]',
          'value': 'true'
          }).after(jQuery('<label>' + label_names[7] + '</label>'));

      if(field.required)
        jQuery(required_checkbox).attr("checked", true);
      form_field.append(required_checkbox);
    }

    if (settings.removeable) {
      var btn_remove = jQuery('<input/>', {
        'class': 'button whith-text icon-remove submit remove-option',
        'style': 'float:right',
        'value': label_names[1],
        'type' : 'button'
      }).click(function() {
        if (confirm(label_names[6]))
        {
          jQuery.ajax({
            url : "former/remove",
            type: "post",
            data: {
              'id': field.id,
              'type' : 'field'
            },
            dataType: "json",
            beforeSend: function() {
              jQuery('#' + gsub_value(id) + 'remove').addClass("small-loading");
            },
            complete : function(response, object) {
              jQuery(escape_selector('#'+id)).remove();
            }
          });
        }

        return false;
      });

      form_field.append(btn_remove);
    }

    form_field.append('<span id="' + gsub_value(id) + 'remove' +'" style="padding: 6px 0 0 0px; float: right; width: 24px; height: 14px;"/>');

    form_field.append('<span class="former-question-label former-line">'+ label_names[3] +'</span>');

    form_field.append('<input id="'+ gsub_value(id) + 'name" name="'+id+'[name]" type="text" value="'+field.name+'" class="former-field-text former-line"/>');

    form_field.append('<span class="former-question-label former-line">'+ label_names[4] +'</span>');

    jQuery.each(field.options, function(index, value) {
        var name_field_option = id+'[options][' + value[0] + ']';
        form_field.append(field_option(field, name_field_option, value[0], value[1]));
    });

    form_field.append(field_new_option(field, id+'[options]', id+'[new_option]', ''));

    return form_field;
}


//Add new option in a field div
function field_new_option(field, options_name, name, value) {
  var btn_div = jQuery('<div/>');
  var options_id = gsub_value(options_name);

  var btn_add = jQuery('<input/>', {
    'value': label_names[0],
    'type': 'button',
    'class': 'button with-text icon-add submit'
  }).click(function() {
    var object_field = jQuery(this);
    var status_id = '[id^='+ options_id + "status"+']' ;
    
    jQuery.ajax({
        url : "former/add_new_option",
        type: "post",
        data: {'field_id': field.id},
        dataType: "json",
        beforeSend: function(){
            jQuery(btn_add).attr("disabled", true);
            jQuery(status_id).addClass("small-loading");
            jQuery(status_id).text('');
        },
        complete: function(response, object){
            var new_field_option = jQuery.parseJSON(response.responseText);
            var new_option = jQuery(field_option(field, options_name + '[' + new_field_option.option_id + ']', new_field_option.option_id, ''));

            jQuery(object_field).before(new_option);
            new_option.children('input').focus();
            jQuery(btn_add).attr("disabled", false);
            jQuery(status_id).removeClass("small-loading");
        }
      });

      return false;
  });

  //Btn save new change options
  var btn_save = jQuery('<input/>', {
      'id': options_id + "save",
      'value': label_names[2],
      'type': 'submit',
      'class': 'button with-text icon-save submit'
  });

  var status = jQuery('<span/>', {
      'id': options_id + "status",
      'style': "padding: 0 0 0 20px"
  });

  btn_div.append(btn_add);
  btn_div.append(btn_save);
  btn_div.append(status);
 
  return btn_div;
}

//Add new field_option in field div.
function field_option(field, input_name, option_id, option_value) {

  var div_field_option = jQuery('<div/>', {
      'class': 'former-field-option former-line'
  });

  var field_option = jQuery('<input/>', {
      'name': input_name,
      'id' : gsub_value(input_name),
      'type': 'text',
      'value': option_value
  });

  var status = jQuery('<span/>', {
      'id'  : gsub_value(input_name) + "status",
      'style' : "padding: 0 0 0 20px"
  });

  var bt_remove = jQuery('<input/>', {
      'class': 'button whith-text icon-remove submit remove-option',
      'value' :label_names[1],
      'type'  :'button'
  
       }).click(function () {
       if (confirm(label_names[5])){
           jQuery.ajax( {
               url : "former/remove",
               type: "post",
               data: {
                   'id': option_id,
                   'type': 'field_option'
               },
               dataType: "json",
               beforeSend: function(){
                   jQuery(bt_remove).attr("disabled", true);
                   jQuery(status).addClass("small-loading");
               },
               complete: function(response, object){
                   jQuery(bt_remove).attr("disabled", false);
                   jQuery(status).removeClass("small-loading");
                   jQuery(field_option).parent('.former-field-option').remove();
               }
           });
       }

        return false;
  });

  div_field_option.append(field_option).append(bt_remove).append(status);

  return div_field_option;
}


function gsub_value(id) {
  return id.replace(/[^a-zA-Z 0-9]+/g,'_');
}

function escape_selector(selector) {
  return selector.replace(/\[/g, '\\[').replace(/\]/g, '\\]');
}

jQuery(document).ready(function() {
    jQuery('#list_fomers').delegate(".title.former-form-name", "click", function(e) {
    e.stopPropagation();
    e.preventDefault();

    var label = jQuery(this);
    if (label.next().is(":visible"))
      label.next(".content-form-accordion").slideUp();
    else
      label.next(".content-form-accordion").slideDown().parent().siblings(".form-accordion-line").find(".content-form-accordion").slideUp();
  });
});

