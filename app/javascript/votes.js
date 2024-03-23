document.addEventListener("turbolinks:load", function () {
  var upvoteLinks = document.querySelectorAll(".upvote-link");
  upvoteLinks.forEach(function (link) {
    link.addEventListener("click", function (e) {
      e.preventDefault();
      var votableType = this.getAttribute("data-votable-type");
      var votableId = this.getAttribute("data-votable-id");
      var url = "/" + votableType + "s/" + votableId + "/upvote";
      var token = document.querySelector('meta[name="csrf-token"]');

      var xhr = new XMLHttpRequest();
      xhr.open("PATCH", url, true);
      if (token) {
        xhr.setRequestHeader("X-CSRF-Token", token.content);
      }
      xhr.setRequestHeader("Content-Type", "application/json");
      xhr.onreadystatechange = function () {
        if (xhr.readyState === XMLHttpRequest.DONE) {
          if (xhr.status === 200) {
            var response = JSON.parse(xhr.responseText);
            var votesCount = response.votes_difference;

            var votesDifferenceElement = document.querySelector(
              "." + votableType + "_votes_difference-" + votableId
            );
            if (votesDifferenceElement) {
              votesDifferenceElement.textContent = votesCount;
            }
          } else {
            console.error("Error while upvoting:", xhr.statusText);
          }
        }
      };
      xhr.send();
    });
  });

  var upvoteLinks = document.querySelectorAll(".downvote-link");
  upvoteLinks.forEach(function (link) {
    link.addEventListener("click", function (e) {
      e.preventDefault();
      var votableType = this.getAttribute("data-votable-type");
      var votableId = this.getAttribute("data-votable-id");
      var url = "/" + votableType + "s/" + votableId + "/downvote";
      var token = document.querySelector('meta[name="csrf-token"]');

      var xhr = new XMLHttpRequest();
      xhr.open("PATCH", url, true);
      if (token) {
        xhr.setRequestHeader("X-CSRF-Token", token.content);
      }
      xhr.setRequestHeader("Content-Type", "application/json");
      xhr.onreadystatechange = function () {
        if (xhr.readyState === XMLHttpRequest.DONE) {
          if (xhr.status === 200) {
            var response = JSON.parse(xhr.responseText);
            var votesCount = response.votes_difference;

            var votesDifferenceElement = document.querySelector(
              "." + votableType + "_votes_difference-" + votableId
            );
            if (votesDifferenceElement) {
              votesDifferenceElement.textContent = votesCount;
            }
          } else {
            console.error("Error while upvoting:", xhr.statusText);
          }
        }
      };
      xhr.send();
    });
  });
});
