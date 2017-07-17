// modal to confirm deleting of account
$('#delete-btn').click(function(event) {
  event.preventdefault();

  $('.tiny.modal').modal('show');

});

<div class="ui modal">
  <div class="header">Header</div>
  <div class="content">
    <p></p>
  </div>
  <div class="actions">
    <div class="ui approve button">Approve</div>
    <div class="ui button">Neutral</div>
    <div class="ui cancel button">Cancel</div>
  </div>
</div>
