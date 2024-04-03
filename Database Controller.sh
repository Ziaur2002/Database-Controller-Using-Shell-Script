#!/bin/bash
ADMIN_PASSWORD="admin"
# Function to show information for Admin
Show_Admin_Info() {
    whiptail --title "Admin Info" --msgbox "User Information:\n\n$(cat user_info.txt)" 20 78
}

# Function to create a user
Create_User() {
    user=$(whiptail --inputbox "Enter your username" 8 39 --title "Create a new user" 3>&1 1>&2 2>&3)
    password=$(whiptail --passwordbox "Enter your password" 8 39 --title "Create a new user" 3>&1 1>&2 2>&3)
    # Store the username and password securely (you might want to enhance the security)
    echo "$user:$password" >> user_info.txt
    whiptail --title "Create a new user" --msgbox "User $user created successfully!" 8 78
}

# Function to authenticate a user
Authenticate_User() {
    user=$(whiptail --inputbox "Enter your username" 8 39 --title "User Login" 3>&1 1>&2 2>&3)
    password=$(whiptail --passwordbox "Enter your password" 8 39 --title "User Login" 3>&1 1>&2 2>&3)
   
    if ! grep -q "^$user:" user_info.txt; then
        whiptail --title "User Login" --msgbox "User does not exist. Please create an account first." 8 78
        exit 1  # Exit the script if the user doesn't exist
    fi
   
    # Check if the username and password match
    if grep -q "$user:$password" user_info.txt; then
        whiptail --title "User Login" --msgbox "Welcome, $user!" 8 78
        return 0  # Return success
    else
        whiptail --title "User Login" --msgbox "Authentication failed. Invalid username or password." 8 78
        return 1  # Return failure
    fi
}

# Function to delete a user (Admin only)
Delete_User() {
    user_to_delete=$(whiptail --inputbox "Enter the username to delete" 8 39 --title "Delete User" 3>&1 1>&2 2>&3)

    # Check if the user exists in the user_info.txt file
    if grep -q "^$user_to_delete:" user_info.txt; then
        # Delete the user from the file
        sed -i "/^$user_to_delete:/d" user_info.txt
        whiptail --title "Delete User" --msgbox "User $user_to_delete deleted successfully!" 8 78
    else
        whiptail --title "Delete User" --msgbox "User $user_to_delete not found!" 8 78
    fi
}

# Admin Panel Function
Admin_Panel() {
	 admin_password=$(whiptail --passwordbox "Enter Admin Password" 8 39 --title "Admin Panel" 3>&1 1>&2 2>&3)
    
    if [ "$admin_password" != "$ADMIN_PASSWORD" ]; then
        whiptail --title "Admin Panel" --msgbox "Incorrect Admin Password. Access denied." 8 78
        return
    fi

    select=$(whiptail --title "Admin Panel" --menu "Choose an option" 25 78 10 \
        "1" "Show user Info" \
        "2" "existing data" \
        "3" "Delete User" \
        "4" "Back to Main Menu" 3>&1 1>&2 2>&3)

    case "$select" in
    1)
        Show_Admin_Info
        ;;
    2)
        whiptail --title "Show Info" --msgbox "$(cat $db)" 30 78
       ;;
    
    3)
        Delete_User
        ;;
    4)
        return
        ;;
    esac
}

Main_Menu_Loop() {
    while true; do
        select=$(whiptail --title "Main Program" --menu "Choose an option" 25 78 10 \
            "1" "Admin Panel" \
            "2" "Login User" \
            "3" "Create User" \
            "4" "Exit" 3>&1 1>&2 2>&3)

        case "$select" in
        1)
            Admin_Panel
            ;;
        2)
            Authenticate_User
            if [ $? -eq 0 ]; then
                Menu_Loop  # Only call Menu if authentication is successful
            fi
            ;;
        3)
            Create_User
            ;;
        4)
            whiptail --title "Exit" --msgbox "! ! Exiting from the program ! !" 8 78
            exit
            ;;
        esac
        done
}
# Main program
Menu_Loop() {
    select=100
    while [ $select -gt 0 ]; do
        select=$(whiptail --title "Data Base Control Unit" --menu "Choose an option" 25 78 10 \
            "1" "Create a database" \
            "2" "Manage an existing database" \
            "3" "Copy a database" \
            "4" "Remove a database from system" \
            "5" "Show the databases" \
            "6" "Quit from Program" \
            "7" "Back to main menu" 3>&1 1>&2 2>&3)
        case "$select" in
        1)
            name=$(whiptail --inputbox "Enter your database name" 8 39 --title "Create a database" 3>&1 1>&2 2>&3)
            touch $name
            whiptail --title "Create a database" --msgbox "! ! Database Created ! !" 8 78
            ;;
        2)
            db=$(whiptail --inputbox "Type your database name" 8 39 --title "Student Database System" 3>&1 1>&2 2>&3)
           menu=100
while [ $menu -gt 0 ]; do
    menu=$(whiptail --title "Manage an existing database" --menu "Choose an option" 25 78 5 \
        "1" "Insertion" \
        "2" "Delete" \
        "3" "Show Info" \
        "4" "Query" \
        "5" "Jump to Home" 3>&1 1>&2 2>&3)
    case "$menu" in
   		
        1) 
         num=$(whiptail --inputbox "Number of entries" 8 39 --title "Insertion" 3>&1 1>&2 2>&3)
         
         if ! [[ "$num" =~ ^[0-9]+$ ]]; then
    whiptail --title "Insertion" --msgbox "Please enter a valid number of entries." 8 78
    # Handle the error condition (exit, return, or take appropriate action)
    exit 1
fi
         
        for ((i = 0; i < num; i++)); do
    id=$(whiptail --inputbox "ID" 8 39 --title "Type your data" 3>&1 1>&2 2>&3)
    nam=$(whiptail --inputbox "Name" 8 39 --title "Type your data" 3>&1 1>&2 2>&3)
    gpa=$(whiptail --inputbox "CGPA" 8 39 --title "Type your data" 3>&1 1>&2 2>&3)
    loc=$(whiptail --inputbox "Location" 8 39 --title "Type your data" 3>&1 1>&2 2>&3)
    bat=$(whiptail --inputbox "Batch" 8 39 --title "Type your Batch" 3>&1 1>&2 2>&3)
    ema=$(whiptail --inputbox "email" 8 39 --title "Type your E-mail" 3>&1 1>&2 2>&3)
    var=" $id $nam $gpa $loc $bat $ema "
    echo " $var " >>$db
    whiptail --title "Insertion" --msgbox "! ! Insertion Complete ! !" 8 78
done
                    ;;
               
                2)
                    ln=$(whiptail --inputbox "Enter the id number" 8 39 --title "Delete" 3>&1 1>&2 2>&3)
                    sed -i "/$ln/d" $db
                    whiptail --title "Deletion" --msgbox "! ! Deletion Complete ! !" 8 78
                    ;;
                3)
                    whiptail --title "Show Info" --msgbox "$(cat $db)" 30 78
                    ;;
                4)
                    query_menu
                    ;;
                5)
                    menu=0
                    ;;
                esac
            done
            ;;
        3)
            copy_db
            ;;
        4)
            remove_db
            ;;
        5)
            whiptail --title "Show the databases" --msgbox "$(ls -p | grep -v /)" 20 78
            ;;
      
           6)
                whiptail --title "Quit from Program" --msgbox "! ! Exiting from the program ! !" 8 78
                exit
                ;;
            7)
                return
                ;;
        esac
    done
}

# Function to handle queries
query_menu() {
    que=100
    while [ $que -gt 0 ]; do
        que=$(whiptail --title "Query" --menu "Choose an option" 25 78 7 \
            "1" "Sort By ID Ascending Order" \
            "2" "Sort By ID Descending Order" \
            "3" "Total number of students" \
            "4" "Search By ID" \
            "5" "Search By Name" \
            "6" "Search By Location" \
            "7" "Jump to Sub menu" 3>&1 1>&2 2>&3)
        case "$que" in
        1)
            whiptail --title "Query" --msgbox "$(sort $db)" 20 78
            ;;
        2)
            whiptail --title "Query" --msgbox "$(sort -r $db)" 20 78
            ;;
        3)
            line=$(wc -l < $db | tr -d ' ')
            whiptail --title "Query" --msgbox "Total number of students: $line " 8 78
            ;;
        4)
            search_id
            ;;
        5)
            search_name
            ;;
        6)
            search_location
            ;;
        7)
            que=0
            ;;
        esac
    done
}

# Function to search by ID
search_id() {
    en=$(whiptail --inputbox "Enter the ID" 8 39 --title "Search By ID" 3>&1 1>&2 2>&3)
    result=$(grep -w "$en" $db)
    
    if [ -n "$result" ]; then
        whiptail --title "Query" --msgbox "$result" 20 78
    else
        whiptail --title "Query" --msgbox "No matching records found for ID: $en" 20 78
    fi
}

# Function to search by name
search_name() {
    en=$(whiptail --inputbox "Enter the name" 8 39 --title "Search By Name" 3>&1 1>&2 2>&3)
    whiptail --title "Query" --msgbox "$(grep $en $db)" 20 78
}

# Function to search by location
search_location() {
    el=$(whiptail --inputbox "Enter the location" 8 39 --title "Search By Location" 3>&1 1>&2 2>&3)
    whiptail --title "Query" --msgbox "$(grep $el $db)" 20 78
}

# Function to copy a database
copy_db() {
    file=$(whiptail --inputbox "Enter file name" 8 39 --title "Copy a database" 3>&1 1>&2 2>&3)
    file1=$(whiptail --inputbox "Enter second file name" 8 39 --title "Copy a database" 3>&1 1>&2 2>&3)
    if [ -f $file ]; then
        cp $file $file1
        whiptail --title "Copy a database" --msgbox "! ! File Copied ! !" 8 78
    else
        whiptail --title "Copy a database" --msgbox "! ! File does not exist ! !" 8 78
    fi
}

# Function to remove a database
remove_db() {
    file=$(whiptail --inputbox "Enter a file name to be removed" 8 39 --title "Remove a database from system" 3>&1 1>&2 2>&3)
    
    if [ -f "$file" ]; then
        rm -i "$file"  # Remove the file
        echo "" > "$file"  # Clear the content of the file
        whiptail --title "Remove a database from system" --msgbox "! ! Database Removed ! !" 8 78
    else
        whiptail --title "Remove a database from system" --msgbox "! ! $file does not exist ! !" 8 78
    fi
}


# Check if users.txt exists and is not empty
if [ ! -e users.txt ]; then
    touch users.txt
fi

#if [ ! -s users.txt ]; then
    #Create_User
#fi

# Execute the main menu loop
Main_Menu_Loop
