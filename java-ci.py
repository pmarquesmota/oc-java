import argparse
import os
import subprocess

def build():
    print("Building the Java project...")
    try:
        result = subprocess.run(["./gradlew", "clean", "compileJava"], capture_output=True, text=True, check=True)
        print(result.stdout)
    except subprocess.CalledProcessError as e:
        print("Failed to build the project.")
        print(e.stdout)
        print(e.stderr)

def test():
    print("Testing the Java project...")
    try:
        result = subprocess.run(["./gradlew", "clean", "test"], capture_output=True, text=True, check=True)
        print(result.stdout)
    except subprocess.CalledProcessError as e:
        print("Failed to test the project.")
        print(e.stdout)
        print(e.stderr)

def pack():
    print("Packaging the Java project into a WAR file...")
    try:
        result = subprocess.run(["./gradlew", "bootWar"], capture_output=True, text=True, check=True)
        print(result.stdout)
    except subprocess.CalledProcessError as e:
        print("Failed to package the project.")
        print(e.stdout)
        print(e.stderr)

def publish():
    print("Publishing the Java project to GitLab Registry...")
    env = {
        "GITLAB_PROJECT_ID": os.getenv("GITLAB_PROJECT_ID"),
        "CI_JOB_TOKEN": os.getenv("CI_JOB_TOKEN")
    }

    try:
        result = subprocess.run(["./gradlew", "publish"], capture_output=True, text=True, check=True, env=env)
        print(result.stdout)
    except subprocess.CalledProcessError as e:
        print("Failed to publish the project.")
        print(e.stdout)
        print(e.stderr)

def main():
    parser = argparse.ArgumentParser(description="CLI for managing Java project CI tasks.")
    parser.add_argument("command", choices=["build", "test", "pack", "publish"], help="Command to run")
    parser.add_argument("--token", help="Deploy token for GitLab")
    parser.add_argument("--project-id", help="GitLab project ID")
    parser.add_argument("--token-name", default="Deploy-Token", help="Name of the deploy token")
    args = parser.parse_args()

    match args.command:
        case "build":
            build()
        case "test":
            test()
        case "pack":
            pack()
        case "publish":
            publish()
        case _:
            raise NameError('Error: Parameter must be build, test, pack, or publish.')

if __name__ == "__main__":
    main()
