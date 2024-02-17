import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Text "mo:base/Text";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
//to do app
actor Assistant {
    type ToDo = {
      description: Text;
      completed: Bool;
    };
    //hashmap
    func natHash(n: Nat) : Hash.Hash {
      Text.hash(Nat.toText(n))
    };

    var toDos = Map.HashMap.Hash<Nat, ToDo>(0, Nat.equal, natHash);
    var nextId : Nat = 0;

    public query func getToDos() : async [ToDo] {
      Iter.toArray(toDos.vals());
    };
    //ID toDo atamasi == sorgu ve tanimlama
    public query func addToDo(description: Text) : async Nat {
      let id = nextId;
      toDos.put(id, {descsription = description; completed = false});
      nextId += 1;
      id
    };
    //update atamasi
    public func completeTodo(id: Nat) : async () {
      ignore do ? {
        let description = toDos.get(id)!.descsription;
        toDos.put(id, {descsription; completed = true});
      }
    };

    public query func showTodos() : async Text {
      var output : Text = "\n____TO-DOs____\n";
      for (todo: ToDo in toDos.vals()) {
        output #= "\n" # todo.description;
        if(todo.completed) {
          output #= "completed";
        };
      };
      output # "\n"
    };

    public func clearCompleted() : async () {
      toDos := Map.mapFilter<Nat, ToDo, ToDo>(toDos, Nat.equal, natHash,
      func (_, todo) {
        if (todo.completed) {
          null
        } else {
          ?todo
        }
      });
    };
};