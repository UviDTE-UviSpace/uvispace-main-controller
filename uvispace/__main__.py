"""
Invokes the main Uvispace package. It launches all uvispace sub packages.
Each sub package goes in a different thread (except GUI that remains in this one)
"""
from uvispace.uvispace import UviSpace

if __name__ == "__main__":
    u = UviSpace().start()
