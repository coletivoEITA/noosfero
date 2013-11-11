
pjax = {

  states: {},
  current_state: null,
  initial_state: null,

  themes: {},

  load: function() {
    var target = jQuery('#content');
    var loadingTarget = jQuery('#content');

    var container = '.pjax-container';
    target.addClass('pjax-container');

    jQuery(document).pjax('a', container);

    jQuery(document).on('pjax:beforeSend', function(event, xhr, settings) {
      var themes = jQuery.map(pjax.themes, function(theme) { return theme.id }).join(',');
      xhr.setRequestHeader('X-PJAX-Themes', themes);
    });

    jQuery(document).on('pjax:send', function(event) {
      /* initial state is only initialized after the first navigation,
       * so we do associate it here */
      if (!pjax.states[jQuery.pjax.state.id])
        pjax.states[jQuery.pjax.state.id] = pjax.initial_state;

      loading_overlay.show(loadingTarget);
    });
    jQuery(document).on('pjax:complete', function(event) {
      loading_overlay.hide(loadingTarget);
    });

    jQuery(document).on('pjax:popstate', function(event) {
      pjax.popstate(event.state, event.direction);
    });

    jQuery(document).on('pjax:timeout', function(event) {
      // Prevent default timeout redirection behavior
      event.preventDefault();
    });
  },

  update: function(state, from_state) {
    if (!from_state)
      from_state = this.current_state || this.initial_state;

    document.body.className = state.body_classes;

    var lt_css = jQuery('head link[href^="/designs/templates"]');
    lt_css.attr('href', lt_css.attr('href').replace(/templates\/.+\/stylesheets/, 'templates/'+state.layout_template+'/stylesheets'));

    render_all_jquery_ui_widgets();

    userDataCallBack(noosfero.user_data);

    if (from_state && state != from_state && state.theme.id != from_state.theme.id)
      this.update_theme(state, from_state);
    else if (state.theme.update_js)
      jQuery.globalEval(state.theme.update_js);

    pjax.current_state = state;
  },

  update_theme: function(state, from_state) {
    var css = jQuery('head link[href^="/designs/themes/'+from_state.theme.id+'/style"]');
    css.attr('href', css.attr('href').replace(/themes\/.+\/style/, 'themes/'+state.theme.id+'/style'));

    jQuery('head link[rel="shortcut icon"]').attr('href', state.theme.favicon);

    jQuery('#theme-header').html(state.theme.header);
    jQuery('#site-title').html(state.theme.site_title);
    jQuery('#navigation ul').html(state.theme.extra_navigation);
    jQuery('#theme-footer').html(state.theme.footer);

    jQuery('head script[src^="/designs/themes/'+from_state.theme.id+'/theme.js"]').remove();
    if (state.theme.js_src) {
      var script = document.createElement('script');
      script.type = 'text/javascript', script.src = state.theme.js_src;
      document.head.appendChild(script);
    }
  },

  popstate: function(state, direction) {
    state = pjax.states[state.id];
    var from_state = pjax.states[jQuery.pjax.state.id];
    pjax.update(state, from_state);
  },

};

// document.write doesn't work after ready state
document._write = document.write;
document.write = function(data) {
  if (document.readyState != 'loading')
    jQuery('body').append(data);
  else
    document._write(data);
};

