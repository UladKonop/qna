document.addEventListener('turbolinks:load', function () {
  var answers = document.querySelector('.answers');
  if (answers) {
    answers.addEventListener('click', function (e) {
      if (e.target.classList.contains('edit-answer-link')) {
        e.preventDefault();
        e.target.style.display = 'none';
        var answerId = e.target.dataset.answerId;

        var editAnswerForm = document.getElementById('edit-answer-' + answerId);
        editAnswerForm.classList.remove('hidden');

        var linkToFileElements = document.querySelectorAll('.answer-' + answerId + '-files .link-to-file a');
        console.log(linkToFileElements);

        linkToFileElements.forEach(function(linkElement) {
            var fileId = linkElement.id.split('-')[1];
          
            var removeLink = document.createElement('a');
            removeLink.setAttribute('data-file-id', fileId);
            removeLink.id = 'remove-file-link-' + fileId;
            removeLink.className = 'remove-file-link';
            removeLink.setAttribute('data-remote', 'true');
            removeLink.setAttribute('rel', 'nofollow');
            removeLink.setAttribute('data-method', 'delete');
            removeLink.href = '/attachments/' + fileId + '/Answer/' + answerId;
            removeLink.textContent = 'x';

            linkElement.parentNode.appendChild(removeLink);
          });
      }
    });
  }
});
