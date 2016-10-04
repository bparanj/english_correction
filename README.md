# English Correction
This is an interview assignment:

Build a standalone Rails backend web service that corrects arbitrary English text, submitted via HTTP request, so that it contains exactly one space after a period between sentences (as prescribed by the rules of modern typesetting). The HTTP response should contain the corrected text along with metadata enumerating the changes (in JSON or your preferred format).

Then, build a browser-based frontend that lets a user submit text to the service via AJAX and renders the corrected version. Include a visual indication or representation of the changes made to the text (up to you what this should look like).

Your code will be judged on the following metrics:

- Observance of best practices per https://github.com/bbatsov/rails-style-guide
- Clarity
- Concision (i.e., don't build more than the spec asks for)
- Ruby/JavaScript best practices
- HTTP best practices
- Handling of edge cases
- Perfect accuracy is less important than those things. Start with the backend portion and get as far as you can.

###UI URL

For local host: `http://localhost:3000/corrections`
