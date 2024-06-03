variable "security" {
  type = object({
    name = string
    vpc_id = string
    rules = list(object({
      type = string
      from_port = number
      to_port = number
      protocol = string
      cidr_blocks = list(string)
    }))
  })
}


resource "aws_security_group" "srt" {
  name = var.security.name
  vpc_id = var.security.vpc_id
  tags = {
    Name = var.security.name
  }
}

resource "aws_security_group_rule" "sert" {
 count = length(var.security.rules)
 security_group_id = aws_security_group.srt.id
 type = var.security.rules[count.index].type
 from_port = var.security.rules[count.index].from_port
 to_port = var.security.rules[count.index].to_port
 protocol = var.security.rules[count.index].protocol
 cidr_blocks = var.security.rules[count.index].cidr_blocks
 depends_on = [
    aws_security_group.srt
   ]
}