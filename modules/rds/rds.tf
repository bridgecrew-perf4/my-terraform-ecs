resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = ["subnet-0bd556aa40f2548d5", "subnet-02499d8fbf9bddf94", "subnet-0f1ff12138854dd14"]

  tags = {
    Name = "My DB subnet group"
  }
}