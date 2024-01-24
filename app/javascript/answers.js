document.addEventListener('turbolinks:load', function () {
    document.querySelector('.answers').addEventListener('click', function (e) {
        if (e.target.classList.contains('edit-answer-link')) {
            e.preventDefault();
            e.target.style.display = 'none';
            var answerId = e.target.dataset.answerId;
            var editAnswerForm = document.getElementById('edit-answer-' + answerId);
            editAnswerForm.classList.remove('hidden');
        }
    });
});
