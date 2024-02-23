document.addEventListener('turbolinks:load', function () {
  var files = document.querySelector('.files');

  if (files) {
    files.addEventListener('click', function (e) {
      if (e.target.classList.contains('remove-file-link')) {
        e.target.parentNode.remove();

        var fileRows = document.querySelectorAll('[class^="remove-file-link"]');

        var newElement = document.createElement('dd');
        newElement.innerHTML = 'No files yet.'; 

        if (fileRows.length === 0) {
          files.insertBefore(newElement, files.children[1]);
        }
      }
    });
  }

  var questions_table = document.querySelector('tbody.questions_table');

  window.App.cable.subscriptions.create('QuestionsChannel', {
    connected: function() {
      this.perform('follow');
    },
    received: function(data) {
      questions_table.insertAdjacentHTML('beforeend', data);
    }
  });
});
