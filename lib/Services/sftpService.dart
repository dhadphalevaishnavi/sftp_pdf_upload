import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:pdf_generator_sftp_upload/Services/toastService.dart';
import 'package:pdf_generator_sftp_upload/constants.dart';
import 'package:ssh2/ssh2.dart';

class SftpService {
  static final sshClient = SSHClient(
      host: SFTP_HOST,
      port: SFTP_PORT,
      username: SFTP_USERNAME,
      passwordOrKey: SFTP_PASSWORD);

  static Future<bool?> uploadPDF(String pdfPath) async {
    try {
      var sshResult = await sshClient.connect();
      if (sshResult == SSH_CONN_SUCC) {
        var sftpResult = await sshClient.connectSFTP();

        if (sftpResult == SFTP_CONN_SUCC) {
          //create folder
          await sshClient.sftpMkdir(FOLDER_NAME);
          // upload PDF file
          await sshClient
              .sftpUpload(path: pdfPath, toPath: FOLDER_NAME)
              .then((uploadStatus) {
            if (uploadStatus == UPLOAD_SUCC) {
              ToastService.toast(
                  "PDF Uploaded Successfully!", Colors.green.shade300);
            } else {
              ToastService.toast("PDF Upload Failed!", Colors.red.shade300);
            }
          });
        }
      }
    } catch (e) {
      ToastService.toast("Something went wrong with SSHClient Connection",
          Colors.red.shade300);
      print(e.toString());
    } finally {
      sshClient.disconnectSFTP();
      sshClient.disconnect();
    }
  }

  static deletePdf(ObjectId? objectId) async {
    final String pdfPath = "$FOLDER_NAME/$objectId.pdf";
    try {
      var sshResult = await sshClient.connect();
      if (sshResult == SSH_CONN_SUCC) {
        var sftpResult = await sshClient.connectSFTP();

        if (sftpResult == SFTP_CONN_SUCC) {
          await sshClient.sftpRm(pdfPath).then((deleteResult) {

            if (deleteResult == DELETE_SUCC) {
              ToastService.toast(
                  "PDF Deleted Successfully!", Colors.green.shade300);
            } else {
              ToastService.toast("PDF Deletion Failed", Colors.red.shade300);
            }
          });
        }
      }
    } catch (e) {
      ToastService.toast("Something went wrong with SSHClient Connection",
          Colors.red.shade300);
      print(e.toString());
    } finally {
      sshClient.disconnectSFTP();
      sshClient.disconnect();
    }
  }

  static updatePDF(ObjectId? objectId, String pdfLocalFilePath) async {
    final String pdfFileServerPath = "$FOLDER_NAME/$objectId.pdf";

    try {
      var sshResult = await sshClient.connect();
      if (sshResult == SSH_CONN_SUCC) {
        var sftpResult = await sshClient.connectSFTP();
        if (sftpResult == SFTP_CONN_SUCC) {
          await sshClient.sftpRm(pdfFileServerPath).then((deleteResult) async {
            print(deleteResult);
            if (deleteResult == DELETE_SUCC) {
             await sshClient
                  .sftpUpload(path: pdfLocalFilePath, toPath: FOLDER_NAME)
                  .then((uploadResult) {
                if (uploadResult == UPLOAD_SUCC) {
                  ToastService.toast(
                      "PDF Updated Successfully!", Colors.green.shade300);
                } else {
                  ToastService.toast("PDF Updated Failed", Colors.red.shade300);
                }
              });
            }
          });
        }
      }
    } catch (e) {
      ToastService.toast("Something went wrong with SSHClient Connection",
          Colors.red.shade300);
      print(e.toString());
    } finally {
      sshClient.disconnectSFTP();
      sshClient.disconnect();
    }
  }
}
