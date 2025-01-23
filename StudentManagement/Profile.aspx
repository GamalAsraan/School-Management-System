<%@ Page Title="Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="StudentManagement.Profile" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            color: #333;
        }
        .section {
            margin-bottom: 30px;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        h2, h3 {
            color: #2c3e50;
        }
        h2 {
            margin-bottom: 20px;
            font-size: 24px;
        }
        h3 {
            margin-bottom: 15px;
            font-size: 20px;
        }
        .grid-view {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        .grid-view th, .grid-view td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        .grid-view th {
            background-color: #4CAF50;
            color: white;
            font-weight: bold;
        }
        .grid-view tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .grid-view tr:hover {
            background-color: #f1f1f1;
        }
        .error-message {
            color: #e74c3c;
            font-weight: bold;
            margin-bottom: 20px;
            padding: 10px;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            border-radius: 4px;
        }
        .btn {
            padding: 8px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s ease;
        }
        .btn-primary {
            background-color: #3498db;
            color: white;
        }
        .btn-primary:hover {
            background-color: #2980b9;
        }
        .btn-danger {
            background-color: #e74c3c;
            color: white;
        }
        .btn-danger:hover {
            background-color: #c0392b;
        }
        .btn-success {
            background-color: #2ecc71;
            color: white;
        }
        .btn-success:hover {
            background-color: #27ae60;
        }
        .btn-warning {
            background-color: #f39c12;
            color: white;
        }
        .btn-warning:hover {
            background-color: #e67e22;
        }
        .confirmation-dialog {
            font-size: 16px;
            color: #333;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="section">
        <h2>Welcome, <asp:Label ID="lblWelcome" runat="server" Text="Student"></asp:Label>!</h2>
    </div>

    <!-- Error Message Display -->
    <div class="section">
        <asp:Label ID="lblMessage" runat="server" CssClass="error-message"></asp:Label>
    </div>

    <!-- Registered Courses Section -->
    <div class="section">
        <h3>Registered Courses</h3>
        <asp:GridView ID="gvRegisteredCourses" runat="server" CssClass="grid-view" AutoGenerateColumns="false" OnRowCommand="gvRegisteredCourses_RowCommand">
            <Columns>
                <asp:BoundField DataField="CourseID" HeaderText="Course ID" />
                <asp:BoundField DataField="CourseName" HeaderText="Course Name" />
                <asp:BoundField DataField="Instructor" HeaderText="Instructor" />
                <asp:BoundField DataField="Credits" HeaderText="Credits" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button runat="server" CommandName="DropCourse" Text="Drop" CssClass="btn btn-danger" CommandArgument='<%# Eval("CourseID") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

    <!-- Available Courses Section -->
    <div class="section">
        <h3>Available Courses</h3>
        <asp:GridView ID="gvAvailableCourses" runat="server" CssClass="grid-view" AutoGenerateColumns="false" OnRowCommand="gvAvailableCourses_RowCommand">
            <Columns>
                <asp:BoundField DataField="CourseID" HeaderText="Course ID" />
                <asp:BoundField DataField="CourseName" HeaderText="Course Name" />
                <asp:BoundField DataField="Instructor" HeaderText="Instructor" />
                <asp:BoundField DataField="Credits" HeaderText="Credits" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button runat="server" CommandName="RegisterCourse" Text="Register" CssClass="btn btn-success" CommandArgument='<%# Eval("CourseID") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

    <!-- Delete All Data Button -->
    <div class="section">
        <asp:Button ID="btnDeleteAllData" runat="server" Text="Delete All Data" CssClass="btn btn-warning" OnClick="btnDeleteAllData_Click" OnClientClick="return confirm('Are you sure you want to delete all your data? This cannot be undone.');" />
    </div>
</asp:Content>