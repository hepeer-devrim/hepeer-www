/* Hepeer — shared site engine.
   Handles i18n text swapping, the EN/TR/DE language switcher and
   localStorage persistence. Each page loads its own dictionary into
   window.HEPEER_I18N before this script, and may register render hooks
   via Hepeer.onRender for page-specific behaviour. */
(function () {
  'use strict';

  var LANGS = ['en', 'tr', 'de'];

  function getLang() {
    try {
      var saved = localStorage.getItem('hepeer_lang');
      return LANGS.indexOf(saved) !== -1 ? saved : 'en';
    } catch (e) { return 'en'; }
  }

  var Hepeer = {
    state: { lang: getLang() },
    T: window.HEPEER_I18N || {},
    onRender: [],

    dict: function () { return this.T[this.state.lang] || this.T.en || {}; },

    setLang: function (l) {
      try { localStorage.setItem('hepeer_lang', l); } catch (e) {}
      this.state.lang = l;
      this.render();
    },

    render: function () {
      var t = this.dict();
      document.documentElement.lang = this.state.lang;

      document.querySelectorAll('[data-i18n]').forEach(function (el) {
        var key = el.getAttribute('data-i18n');
        if (t[key] !== undefined) el.textContent = t[key];
      });

      document.querySelectorAll('[data-lang]').forEach(function (b) {
        b.classList.toggle('is-active', b.getAttribute('data-lang') === Hepeer.state.lang);
      });

      this.onRender.forEach(function (fn) { fn(t, Hepeer.state); });
    }
  };

  function init() {
    document.querySelectorAll('[data-lang]').forEach(function (b) {
      b.addEventListener('click', function () { Hepeer.setLang(b.getAttribute('data-lang')); });
    });
    // Page-specific setup registered before this script loaded.
    (window.HEPEER_INIT || []).forEach(function (fn) { fn(Hepeer); });
    Hepeer.render();
  }

  window.Hepeer = Hepeer;

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
