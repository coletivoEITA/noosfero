email = {

  conversations: {
    url: '',
    template: '',
    view: '',

    index: function(label) {
      jQuery.getJSON(this.url.format({action: 'index'}), {label: label}, function(data) {
        email.conversations.data = data;
        email.conversations.view.html(email.conversations.template({conversations: email.conversations.data}));
      });
    },

    open: {
      template: '',
      view: '',

      click: function(id) {
        var conversation = email.conversations.data[id];
        email.conversations.view.toggle();
        email.conversations.open.view.toggle();
        email.conversations.open.view.html(email.conversations.open.template({conversation: conversation}));
      },
    },
  },
};

_.templateSettings = {
  evaluate: /\{\{([\s\S]+?)\}\}/g,
  interpolate: /\{\{=([\s\S]+?)\}\}/g,
  escape: /\{\{-([\s\S]+?)\}\}/g
}

String.prototype.format = function(obj) {
  return this.replace(/%\{([^}]+)\}/g,function(_,k){ return obj[k] });
};

