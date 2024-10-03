import { findUserById, updateUser } from "./users.services";

async function getUserById(req: Request, res: Response) {
    try {
        const user = await findUserById(req.params.id)
        if (!user) {
            res.status(404).send('User not found')
            return
        }
        res.status(200).send(user)
    }
    catch (err) {
        console.error(err)
    }
}

async function updateUserController(req: Request, res: Response) {
    try {
        const user = await findUserById(req.params.id)
        if (!user) {
            res.status(404).send('User not found')
            return
        }
        user.name = req.body.name
        user.surname = req.body.surname
        user.email = req.body.email
        await updateUser(user)
        res.status(200).send(user)
    }
    catch (err) {
        console.error(err)
    }
}

export { getUserById, updateUserController };

