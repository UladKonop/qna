document.addEventListener("turbolinks:load", function () {
  const currentUrl = window.location.pathname;
  const pathSegments = currentUrl.split("/");

  let context, itemId;
  if (pathSegments.length >= 2) {
    context = pathSegments[1];
    itemId = pathSegments[2];

    if (context === "questions" && itemId) {
      subscribeToQuestionForCommentsAndAnswers(itemId);
    } else if (context === "answers" && itemId) {
      subscribeToCommentsForAnswer(itemId);
    }
  }
  subscribeToQuestions();
});

function subscribeToQuestions() {
  var questions_table = document.querySelector("tbody.questions_table");
  if (questions_table) {
    window.App.cable.subscriptions.create("QuestionsChannel", {
      connected: function () {
        this.perform("follow");
      },
      received: function (data) {
        questions_table.insertAdjacentHTML("beforeend", data);
      },
    });
  }
}

function subscribeToQuestionForCommentsAndAnswers(questionId) {
  var comments = document.querySelector(".comments");
  if (comments) {
    window.App.cable.subscriptions.create(
      { channel: "CommentsChannel", question_id: questionId },
      {
        connected: function () {
          this.perform("follow");
        },
        received: function (data) {
          comments.insertAdjacentHTML("beforeend", data);
        },
      }
    );
  }

  var answers = document.querySelector(".answers");
  if (answers) {
    window.App.cable.subscriptions.create(
      { channel: "AnswersChannel", question_id: questionId },
      {
        connected: function () {
          this.perform("follow");
        },
        received: function (data) {
          answers.insertAdjacentHTML("beforeend", data);
        },
      }
    );
  }
}

function subscribeToCommentsForAnswer(answerId) {
  var comments = document.querySelector(".comments");
  if (comments) {
    window.App.cable.subscriptions.create(
      { channel: "CommentsChannel", answer_id: answerId },
      {
        connected: function () {
          this.perform("follow");
        },
        received: function (data) {
          comments.insertAdjacentHTML("beforeend", data);
        },
      }
    );
  }
}
