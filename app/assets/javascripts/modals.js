
// Popup modal for deleting account
$(document).ready(function() {

  // check if the form exists
  if (document.location.pathname.endsWith("/cancel-account")) {

    var deleteBtn = document.getElementById('delete-btn');
    deleteBtn.addEventListener('click', function(event) {
      $('.tiny.modal').modal('show');
    });
    
  };

});
