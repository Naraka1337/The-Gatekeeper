<?php
// Gatekeeper Control API - feature/interactive-dashboard
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    $action = $input['action'] ?? '';
    $ip = $input['ip'] ?? '';

    if ($action === 'unban' && filter_var($ip, FILTER_VALIDATE_IP)) {
        // Execute unban command via sudo
        $command = "sudo /usr/bin/fail2ban-client unban " . escapeshellarg($ip);
        exec($command, $output, $return_var);

        if ($return_var === 0) {
            echo json_encode(['success' => true, 'message' => "IP $ip has been unbanned successfully."]);
        } else {
            echo json_encode(['success' => false, 'message' => "Failed to unban IP $ip.", 'details' => $output]);
        }
    } else {
        echo json_encode(['success' => false, 'message' => 'Invalid action or IP address.']);
    }
    exit;
}

echo json_encode(['success' => false, 'message' => 'Invalid request method.']);
?>
