// Add this line to include Stripe.js
//= require stripe

document.addEventListener('DOMContentLoaded', function() {
  var stripe = Stripe('pk_test_51Q3bPDLbFx0KuzUZvg45GbWWJHdBQAFSChdXq9sVPJVZ5Swd6HxtgEJEmBdpTTRulgDqbhp9bpKuV3XmQGH0PFLW00F0Lr0ma2'); // Replace with your public Stripe key
  var elements = stripe.elements();
  var cardElement = elements.create('card');
  cardElement.mount('#card-element');

  var form = document.getElementById('payment-form');
  form.addEventListener('submit', function(event) {
    event.preventDefault();

    stripe.createToken(cardElement).then(function(result) {
      if (result.error) {
        document.getElementById('card-errors').textContent = result.error.message;
      } else {
        var hiddenInput = document.createElement('input');
        hiddenInput.setAttribute('type', 'hidden');
        hiddenInput.setAttribute('name', 'stripeToken');
        hiddenInput.setAttribute('value', result.token.id);
        form.appendChild(hiddenInput);
        form.submit();
      }
    });
  });
});





//= require stripe