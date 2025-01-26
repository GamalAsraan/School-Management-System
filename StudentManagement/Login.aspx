<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="StudentManagement.Login" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .form-container {
            max-width: 400px;
            margin: 40px auto;
            padding: 30px;
            border: 1px solid #e1e1e1;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            background-color: #ffffff;
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 25px;
            font-size: 24px;
        }

        .input-group {
            margin-right:18px;
            margin-bottom: 20px;
        }

        .input-group label {
            display: block;
            margin-bottom: 5px;
            color: #555;
            font-weight: 500;
        }

        .input-group input {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }

        .input-group input:focus {
            outline: none;
            border-color: #4A90E2;
            box-shadow: 0 0 0 2px rgba(74,144,226,0.2);
        }

        .btn {
            width: 100%;
            padding: 10px;
            background-color: #2ecc71;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 500;
            margin-top: 10px;
            transition: background-color 0.3s ease;
        }

        .btn:hover {
            background-color: #27ae60;
        }

        .error-message {
            color: #dc3545;
            font-size: 14px;
            margin-top: 5px;
            text-align: center;
        }

        .form-toggle {
            text-align: center;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }

        .form-toggle a {
            cursor: pointer;
            color: #4A90E2;
            text-decoration: none;
            font-weight: 500;
        }

        .form-toggle a:hover {
            text-decoration: underline;
        }

        .hidden {
            display: none !important;
        }

        /* Animation for form switching */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        #loginForm, #signupForm {
            animation: fadeIn 0.3s ease-out;
        }
    </style>
    <script type="text/javascript">
        function toggleForm() {
            var loginForm = document.getElementById("loginForm");
            var signupForm = document.getElementById("signupForm");
            var toggleLink = document.getElementById("toggleLink");

            // Check if login form is hidden
            if (loginForm.classList.contains("hidden")) {
                // Show login form
                loginForm.classList.remove("hidden");
                signupForm.classList.add("hidden");
                toggleLink.innerHTML = "Don't have an account? <a onclick='toggleForm()'>Register here</a>";
            } else {
                // Show signup form
                loginForm.classList.add("hidden");
                signupForm.classList.remove("hidden");
                toggleLink.innerHTML = "Already have an account? <a onclick='toggleForm()'>Login here</a>";
            }
        }

        // Initialize the forms on page load
        window.onload = function () {
            var loginForm = document.getElementById("loginForm");
            var signupForm = document.getElementById("signupForm");

            // Make sure login form is visible and signup is hidden initially
            loginForm.classList.remove("hidden");
            signupForm.classList.add("hidden");
        };
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="form-container">
        <!-- Login Form -->
        <div id="loginForm">
            <h2>Login</h2>
            <div class="input-group">
                <asp:Label ID="lblUsername" runat="server" Text="Username"></asp:Label>
                <asp:TextBox ID="txtUsername" runat="server" placeholder="Enter your username"></asp:TextBox>
            </div>
            <div class="input-group">
                <asp:Label ID="lblPassword" runat="server" Text="Password"></asp:Label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Enter your password"></asp:TextBox>
            </div>
            <asp:Button ID="btnLogin" runat="server" Text="Login" OnClick="btnLogin_Click" CssClass="btn" />
            <asp:Label ID="lblMessage" runat="server" CssClass="error-message"></asp:Label>
        </div>

        <!-- Sign Up Form -->
        <div id="signupForm" class="hidden">
            <h2>Sign Up</h2>
            <div class="input-group">
                <asp:Label ID="lblSignupFullName" runat="server" Text="Full Name"></asp:Label>
                <asp:TextBox ID="txtSignupFullName" runat="server" placeholder="Enter your full name"></asp:TextBox>
            </div>
            <div class="input-group">
                <asp:Label ID="lblSignupEmail" runat="server" Text="Email"></asp:Label>
                <asp:TextBox ID="txtSignupEmail" runat="server" placeholder="Enter your email"></asp:TextBox>
            </div>
            <div class="input-group">
                <asp:Label ID="lblSignupUsername" runat="server" Text="Username"></asp:Label>
                <asp:TextBox ID="txtSignupUsername" runat="server" placeholder="Choose a username"></asp:TextBox>
            </div>
            <div class="input-group">
                <asp:Label ID="lblSignupPassword" runat="server" Text="Password"></asp:Label>
                <asp:TextBox ID="txtSignupPassword" runat="server" TextMode="Password" placeholder="Choose a password"></asp:TextBox>
            </div>
            <!-- Sign Up Button -->
<asp:Button ID="btnSignUp" runat="server" Text="Sign Up" OnClick="btnSignUp_Click" CssClass="btn" />
            <asp:Label ID="lblSignupMessage" runat="server" CssClass="error-message"></asp:Label>
        </div>

        <!-- Toggle Link -->
        <div class="form-toggle" id="toggleLink">
            Don't have an account? <a onclick="toggleForm()">Register here</a>
        </div>
    </div>
</asp:Content>