
// Popup modal for
$(document).ready(function() {

  // check if the form exists
  if (document.getElementById('delete-btn')) {

    var deleteBtn = document.getElementById('delete-btn');
    deleteBtn.addEventListener('click', function(event) {
      $('.tiny.modal').modal('show');
    });
  };

});
