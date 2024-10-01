// Initialize Stripe with your public key
const stripe = Stripe('pk_test_51Q3bPDLbFx0KuzUZvg45GbWWJHdBQAFSChdXq9sVPJVZ5Swd6HxtgEJEmBdpTTRulgDqbhp9bpKuV3XmQGH0PFLW00F0Lr0ma2'); // Replace with your Stripe public key
const elements = stripe.elements();

// Create an instance of the card Element
const card = elements.create('card');
card.mount('#card-element');

// Handle form submission
const form = document.getElementById('payment-form');
form.addEventListener('submit', function(event) {
    event.preventDefault();

    stripe.createToken(card).then(function(result) {
        if (result.error) {
            // Display error in #card-errors
            document.getElementById('card-errors').textContent = result.error.message;
        } else {
            // Send the token to your server
            const hiddenInput = document.createElement('input');
            hiddenInput.setAttribute('type', 'hidden');
            hiddenInput.setAttribute('name', 'stripeToken');
            hiddenInput.setAttribute('value', result.token.id);
            form.appendChild(hiddenInput);

            // Submit the form
            form.submit();
        }
    });
});
