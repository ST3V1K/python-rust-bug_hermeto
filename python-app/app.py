from cryptography.fernet import Fernet


def main() -> None:
    key = Fernet.generate_key()
    f = Fernet(key)
    token = f.encrypt(b"Hello from hermeto bug reproducer!")
    print(f.decrypt(token).decode())


if __name__ == "__main__":
    main()
