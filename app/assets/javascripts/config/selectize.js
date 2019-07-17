//= require microplugin/microplugin.min
//= require sifter/sifter.min
//= require selectize/selectize.min

WAlgProg.selectize = {};

$(document).on('turbolinks:load', () => {
  WAlgProg.selectize.init();
});

$(document).on('turbolinks:before-cache', () => {
  WAlgProg.selectize.clearCache();
});

WAlgProg.selectize.init = () => {
  const selects = $('.apply-selectize');

  if (selects.length > 0) {
    selects.selectize();
    $('.selectize-input input[placeholder]').attr('style', 'width: 100%;');
  }
};

WAlgProg.selectize.clearCache = () => {
  const selects = $('.selectized');
  if (selects.length < 1) return;

  selects.each((index, select) => {
    if (select.selectize) {
      select.selectize.destroy();
    }
  });
};
