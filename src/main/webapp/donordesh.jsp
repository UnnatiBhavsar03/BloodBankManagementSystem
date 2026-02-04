

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="headerfooter.css">
<style>
    /* Reset and base styles */
  * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body, html {
      height: 100%;
      font-family: Arial, sans-serif;
      background-color: #f9f9f9;
    }

    header, footer {
      background-color: #d32f2f;
      color: white;
      text-align: center;
      padding: 15px 0;
    }

    .container {
      height:500px; /* 100% viewport height - header + footer */
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      text-align: center;
      padding: 20px;
    }

    .welcome-message {
      margin-bottom: 20px;
    }

    .welcome-message h1 {
      font-size: 2.5em;
      color: #d32f2f;
      margin-bottom: 10px;
    }

    .welcome-message p {
      font-size: 1.2em;
      color: #555;
    }

    .dashboard-image img {
      max-width: 100%;
      height: 350px; /* You can adjust height here */
      object-fit: cover;
      border-radius: 10px;
      box-shadow: 0 4px 8px rgba(0,0,0,0.2);
    }

    footer {
      font-size: 0.9em;
    }
    
  </style>
</head>
<body>
<div id="donorheader-container"></div>
<div class="container">
    <div class="welcome-message">
      <h1>Welcome, <%= session.getAttribute("email") %>!</h1>
      <p>Thank you for choosing to save lives. Every drop matters!</p>
    </div>

    <div class="dashboard-image">
      <img src="donordashimg.jpeg" alt="Blood Donation Image"> <!-- Replace with your image path -->
    </div>
  </div>

<div>
<div id="footer-container"></div>  <!-- Footer will be loaded here -->
</div>
    <script src="main.js"></script>
</body>
</html>