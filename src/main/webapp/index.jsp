<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <title>Welcome</title>
    <style>
        body {
            background-color: #f0f8ff; /* Light blue background */
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
        }

        .container {
            text-align: center;
            margin-top: 100px;
        }

        h2 {
            color: #2e8b57; /* Forest green */
            font-size: 3em;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3); /* Text shadow */
            font-weight: bold;
        }

        .box {
            background-color: #ffffff; /* White background */
            border: 2px solid #2e8b57; /* Forest green border */
            border-radius: 15px; /* Rounded corners */
            padding: 30px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* Shadow effect */
            width: 60%;
            margin: 0 auto;
            text-align: center;
        }

        .button {
            display: inline-block;
            background-color: #2e8b57;
            color: white;
            padding: 15px 30px;
            font-size: 1.2em;
            border-radius: 30px;
            text-decoration: none;
            margin-top: 20px;
            transition: background-color 0.3s ease;
        }

        .button:hover {
            background-color: #3cb371; /* Lighter green on hover */
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="box">
            <h2>Welcome to M Brothers International</h2>
            <p>We're glad to have you here. Explore our services.</p>
            <a href="#" class="button">Explore More</a>
        </div>
    </div>
</body>
</html>
