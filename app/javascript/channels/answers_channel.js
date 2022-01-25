import consumer from "./consumer";

consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
  connected() {
    this.perform('follow');
  },
  received(data) {
    var answer = data.answer;
      if (gon.current_user_id != answer.user_id) {
        $('.answers').append(data.partial);
    }
  },
})
