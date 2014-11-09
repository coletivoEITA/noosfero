noosfero.modal = {

  watchClass: function() {
    jQuery(function($) {
      $(document).delegate('.modal-toggle', 'click', function() {
        $.colorbox({
          href:       $(this).attr('href'),
          maxWidth:   $(window).width()-50,
          height:     $(window).height()-50,
          open:       true,
          close:      'Cancel',
          class:      'modal',
          onComplete: function(bt) {
            var opt = {}, maxH = $(window).height()-50;
            if ($('#cboxLoadedContent *:first').height() > maxH) opt.height = maxH;
            $.colorbox.resize(opt);
          }
        });
        return false;
      });

      $(document).delegate('.modal-close', 'click', function() {
        $.colorbox.close();
        return false;
      });

    });
  },

  inline: function(href, options) {
    href = jQuery(href);
    options = jQuery.extend({
      inline: true, href: href,
      onLoad: function(){ href.show(); },
      onCleanup: function(){ href.hide(); },
    }, options)

    jQuery.colorbox(options);

    return false;
  },

  html: function(html, options) {
    options = jQuery.extend({
      html: html,
    }, options);

    jQuery.colorbox(options);
  },

  close: function() {
    jQuery.colorbox.close();
  },

};

noosfero.modal.watchClass();

