$(document).on('turbolinks:load', () => {
  WAlgProg.disableBrowserAutocomple();
});

WAlgProg.disableBrowserAutocomple = () => {
  setTimeout(() => { $('input').attr('autocomplete', 'nope'); }, 1000);
};
